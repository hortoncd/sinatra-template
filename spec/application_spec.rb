require 'rack_test_spec_helper'

describe 'Helpers' do
  subject do
    Class.new { include AppHelpers }
  end
  it "should have a helper that correctly escapes html" do
    expect(subject.new.escape('<head>Test</head>')).to eq('&lt;head&gt;Test&lt;&#x2F;head&gt;')
  end
end

describe 'Web Service' do
  it 'should load the home page' do
    visit '/'
    expect(page.status_code).to be(200)
    expect(page).to have_title app.settings.title
  end

  it "should have the correct navbar-brand for '/'" do
    visit '/'
    expect(page.status_code).to be(200)
    expect(page).to have_content "#{app.settings.title} : "
  end

  it 'should show error page for an undefined page' do
    visit '/test'
    expect(page.status_code).to be(404)
    expect(page).to have_title "Error: 404"
    expect(page).to have_content "This is not the page you're looking for (hand-waviness here)"
  end

  app.settings.pages.each do |p|
    it "should load '#{p['name']}'" do
      get p['name']
      expect(last_response).to be_ok
    end

    it "should have the correct page title on a GET of the '#{p['name']}' page" do
      visit p['name']
      expect(page.status_code).to be(200)
      expect(page).to have_title p['title']
    end

    it "should have the correct navbar-brand on a GET of the '#{p['name']}' page" do
      visit '/'
      expect(page.status_code).to be(200)
      expect(page).to have_content "#{app.settings.title} : "
    end

    it "should have the correct page content on a GET of the '#{p['name']}' page" do
      visit p['name']
      expect(page.status_code).to be(200)
      expect(page).to have_title p['title']
    end

    # post tests just for coverage since the posts don't do anything different
    it "should have the correct page content on a POST of the '#{p['name']}' page" do
      # Interesting, apparently have to visit before post to avoid random failures?
      visit p['name']
      headers = {
        "ACCEPT" => "text/html"
      }
      post p['name'], "Test", headers
      expect(page.status_code).to eq(200)
      expect(page).to have_title p['title']
    end
  end
end
