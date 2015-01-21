require 'rails_helper'

RSpec.describe "Jobs", type: :request, js: true do

  describe 'Anonymous User' do
    before(:each) do
      @job = FactoryGirl.create :job
      visit jobs_path
      expect(page).to have_selector(get_html_id(@job))
      expect(page).to_not have_link('New Job')
    end

    describe 'permissions' do
      it 'requires authentication to create or edit a company' do
        requires_sign_in new_job_path
        requires_sign_in edit_job_path(@job)
      end
    end

    describe 'Rest actions' do
      it 'lists all jobs' do
        @jobs = FactoryGirl.create_list :job, 5
        refresh_page # because we created 5 jobs that weren't on the page

        @jobs.each do |job|
          validate_job_in_table job
        end
      end

      it 'shows a job' do
        click_link_in_row @job, 'Show'
        expect(page).to_not have_link('Edit', href: edit_job_path(@job))
        currency_attributes = %w{ salary_min salary_max }
        attributes = job_attributes - currency_attributes - %w{ company_id }
        expect(page).to have_content("Company: #{@job.company.name}")
        attributes.each do |attribute|
          expect(page).to have_content("#{attribute.humanize}: #{@job.send(attribute)}")
        end
        currency_attributes.each do |currency_attribute|
          expect(page).to have_content("#{currency_attribute.humanize}: #{number_to_currency(@job.send(currency_attribute), precision: 0)}")
        end
        expect(current_path).to eq(job_path(@job))
      end
    end
  end

  describe 'Admin' do
    before(:each) do
      @admin = FactoryGirl.create :admin
      sign_in @admin
    end

    describe 'Rest actions' do
      before(:each) do
        @job = FactoryGirl.create :job
        visit jobs_path
        expect(page).to have_selector(get_html_id(@job))
      end

      it 'lists all jobs' do
        @jobs = FactoryGirl.create_list :job, 5
        refresh_page # because we created 5 jobs that weren't on the page

        @jobs.each do |job|
          validate_job_in_table job
        end
      end

      it 'create a job' do
        @new_job = FactoryGirl.build :job

        click_link 'New Job'
        fill_in_job_form @new_job

        expect(page).to have_content('Job was successfully created.')
        expect(current_path).to eq(job_path(Job.last))
        validate_last_job_in_db @new_job
      end

      it 'edits a job' do
        @new_job = FactoryGirl.build :job, remote_ok: !@job.remote_ok

        click_link_in_row @job, 'Edit'
        fill_in_job_form @new_job

        expect(page).to have_content('Job was successfully updated.')
        expect(current_path).to eq(job_path(@job))
        validate_last_job_in_db @new_job
      end

      it 'shows a job' do
        click_link_in_row @job, 'Show'
        expect(page).to have_link('Edit', href: edit_job_path(@job))
        currency_attributes = %w{ salary_min salary_max }
        attributes = job_attributes - currency_attributes - %w{ company_id }
        expect(page).to have_content("Company: #{@job.company.name}")
        attributes.each do |attribute|
          expect(page).to have_content("#{attribute.humanize}: #{@job.send(attribute)}")
        end
        currency_attributes.each do |currency_attribute|
          expect(page).to have_content("#{currency_attribute.humanize}: #{number_to_currency(@job.send(currency_attribute), precision: 0)}")
        end
        expect(current_path).to eq(job_path(@job))
      end

      it 'destroys a job' do
        click_link_in_row @job, 'Destroy'
        expect(page).to have_content('Job was successfully destroyed.')
        expect(current_path).to eq(jobs_path)
        expect{@job.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  def fill_in_job_form job
    checkboxes = %w{ remote_ok }
    arrays = %w{ tags }
    attributes = job_attributes - checkboxes - arrays
    attributes.each do |attribute|
      fill_in "job[#{attribute}]", with: job.send(attribute)
    end

    arrays.each do |array|
      fill_in "job[#{array}]", with: job.send(array).join(', ')
    end

    checkboxes.each do |checkbox|
      name = "job[#{checkbox}]"
      job.send(checkbox) ? check(name) : uncheck(name)
    end

    click_button 'Save'
  end

  def validate_job_in_table job
    within get_html_id(job) do
      %w{title location compensation_summary}.each do |attribute|
        expect(page).to have_content(job.send(attribute))
      end
      expect(page).to have_link('Angellist', href: job.angellist_url) unless job.angellist_url.blank?
    end
  end

  def validate_last_job_in_db job
    job_in_db = Job.last
    job_attributes.each do |attribute|
      if job_in_db.send(attribute).blank? # nil or "" are the same for our purposes
        byebug if job_in_db.send(attribute).blank? != job.send(attribute).blank?
        expect(job_in_db.send(attribute).blank?).to eq(job.send(attribute).blank?)
      else
        expect(job_in_db.send(attribute)).to eq(job.send(attribute))
      end
    end
  end

  def job_attributes
    @job.attributes.keys - %w{id created_at updated_at}
  end

end
