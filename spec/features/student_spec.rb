require 'byebug'
require 'rails_helper'

describe 'Route to view' do
  it 'has an index page' do
    visit students_path
    expect(page.status_code).to eq(200)
  end
end

describe 'Multiple students' do
  it 'shows them on the index page' do
    Student.create!(first_name: "Ash", last_name: "Zaki")
    Student.create!(first_name: "Ryan", last_name: "Zaki")

    visit students_path
    expect(page).to have_content(/Ash|Ryan/)
  end
end

describe 'Show page' do
  before do
    @student = Student.create!(first_name: "Ash", last_name: "Zaki")
  end

  it 'renders properly' do
    visit student_path(@student)
    expect(page.status_code).to eq(200)
  end

  it 'renders the first name in a h1 tag' do
    visit student_path(@student)
    expect(page).to have_css("h1", text: "Ash")
  end

  it 'renders the last name in a h1 tag' do
    visit student_path(@student)
    expect(page).to have_css("h1", text: "Zaki")
  end

  it 'renders the active status if the user is inactive' do
    visit student_path(@student)
    expect(page).to have_content("This student is currently inactive.")
  end

  it 'renders the active status if the user is active' do
    @student.active = true
    @student.save
    visit student_path(@student)
    expect(page).to have_content("This student is currently active.")
  end
end

describe 'Activate page' do
  before do
    @student = Student.create!(first_name: "Ash", last_name: "Zaki")
  end

  it "Should mark an inactive stuent as active" do
    visit activate_student_path(@student)
    @student.reload
    expect(@student.active).to eq(true)
  end

  it "Should mark an active student as inactive" do
    @student.active = true
    @student.save
    visit activate_student_path(@student)
    @student.reload
    expect(@student.active).to eq(false)
  end

  it "Should redirect to the student show page" do
    visit activate_student_path(@student)
    expect(page.current_path).to eq(student_path(@student))
  end
end

describe 'linking from the index page to the show page' do
  it 'index page links to post page' do
    @student = Student.create!(first_name: "Ash", last_name: "Zaki")
    visit students_path
    expect(page).to have_link(@student.to_s, href: student_path(@student))
  end
end
