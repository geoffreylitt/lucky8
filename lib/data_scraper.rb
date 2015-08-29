require "open-uri"
require "nokogiri"

class DataScraper
  attr_reader :school, :id
  def initialize(school)
    @school = school
    @id = school.org_id_number
  end

  def scrape
    return if id.nil?

    scrape_general
    scrape_grad_rates
    scrape_postgrad_intentions
    scrape_school_size_and_race
    scrape_attendance_rate
    scrape_ell_percentage
    scrape_avg_class_size

    school.save!
  end

  # For all schools in the db, pull newest data from the Mass DESE site
  def self.scrape_all
    School.all.each do |school|
      puts "Scraping data for #{school.name}..."
      DataScraper.new(school).scrape
    end
  end

  private

  def scrape_general
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/profiles/general.aspx?topNavId=1&orgcode=#{id}&orgtypecode=6&"))

    # scrape address
    doc.css("#whiteboxRight tr").each do |row|
      columns = row.css("td")
      if columns.size >= 2
        case columns.first.text.strip
        when "Mailing Address:"
          set_field_if_blank(:address, columns[1].text.strip)
        when "Phone:"
          set_field_if_blank(:phone, columns[1].text.strip)
        end
      end
    end
  end

  def scrape_grad_rates
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/grad/grad_report.aspx?orgcode=#{id}&orgtypecode=6&"))

    grad_rates_tr_header = doc.css("td").select{ |td| td.text == "4-Year Graduation Rate  (2014)" }
    if grad_rates_tr_header.present?
      grad_rates_tr = grad_rates_tr_header.first.parent.parent.css("tr.ccc")
      rates = grad_rates_tr.css("td").map{ |td| td.text.strip.to_f }

      set_field_if_blank(:four_yr_graduated, rates[2])
      set_field_if_blank(:four_yr_still_in_school, rates[3])
      set_field_if_blank(:four_yr_ged, rates[5])
      set_field_if_blank(:four_yr_dropped_out, rates[6])
    end
  end

  def scrape_postgrad_intentions
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/profiles/student.aspx?orgcode=#{id}&orgtypecode=6&leftNavId=307&"))

    four_year_private = scrape_table_row(doc: doc, row_name: "4-Year Private College")
    four_year_public = scrape_table_row(doc: doc, row_name: "4-Year Public College")
    two_year_private = scrape_table_row(doc: doc, row_name: "2-Year Private College")
    two_year_public = scrape_table_row(doc: doc, row_name: "2-Year Public College")
    unknown = scrape_table_row(doc: doc, row_name: "Unknown")

    if four_year_private && four_year_public
      set_field_if_blank(:post_grad_four_yr_college, four_year_private + four_year_public)
    end

    if two_year_private && two_year_public
      set_field_if_blank(:post_grad_two_yr_college, two_year_private + two_year_public)
    end

    set_field_if_blank(:post_grad_unknown, unknown)
  end

  def scrape_school_size_and_race
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/profiles/student.aspx?orgcode=#{id}&orgtypecode=6&"))

    # Scrape school size by grade

    enrollment_table_header = doc.css("th").select do |th|
      th.text.strip.include? "Enrollment by Grade"
    end

    if enrollment_table_header.present?
      enrollment_table = enrollment_table_header.first.parent.parent.parent

      nums = enrollment_table.css("tr").last.css("td").map{ |td| td.text.strip }

      set_field_if_blank(:school_size_9_grade, nums[11].to_i)
      set_field_if_blank(:school_size_10_grade, nums[12].to_i)
      set_field_if_blank(:school_size_11_grade, nums[13].to_i)
      set_field_if_blank(:school_size_12_grade, nums[14].to_i)
      set_field_if_blank(:school_size_unknown, nums[16].to_i)
    end

    # Scrape demographic breakdown

    race_table_header = doc.css("th").select do |th|
      th.text.strip.include? "Race/Ethnicity"
    end

    if race_table_header.present?
      race_table = race_table_header.first.parent.parent

      race_percentages = race_table.css("tr").each_with_object({}) do |tr, hsh|
        if tr.css("td").length > 2
          hsh[tr.css("td").first.text.strip] = tr.css("td")[1].text.strip.to_f
        end
      end

      set_field_if_blank(:school_population_african_american, race_percentages["African American"])
      set_field_if_blank(:school_population_asian, race_percentages["Asian"])
      set_field_if_blank(:school_population_hispanic, race_percentages["Hispanic"])
      set_field_if_blank(:school_population_white, race_percentages["White"])
      set_field_if_blank(:school_population_multi_race_non_hispanic, race_percentages["Multi-Race, Non-Hispanic"])
    end
  end

  def scrape_attendance_rate
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/profiles/student.aspx?orgcode=#{id}&orgtypecode=6&leftNavId=303&"))
    attendance_rate = scrape_table_row(doc: doc, row_name: "Attendance Rate")
    set_field_if_blank(:attendance_rate, attendance_rate)
  end

  def scrape_ell_percentage
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/profiles/student.aspx?orgcode=#{id}&orgtypecode=6&leftNavId=305&"))
    ell_percentage = scrape_table_row(doc: doc, row_name: "English Language Learner")
    set_field_if_blank(:ell_percentage, ell_percentage)
  end

  def scrape_avg_class_size
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/students/classsizebygenderpopulation.aspx?orgcode=#{id}&fycode=2015&orgtypecode=6&"))
    avg_class_size = scrape_table_row(doc: doc, row_name: "Average Class Size")
    set_field_if_blank(:avg_class_size, avg_class_size)
  end

  # Finds a table row with a given label on a web page,
  # and returns a number from that row.
  #
  # @param doc [Nokogiri::HTML::Document] Nokogiri doc with the webpage
  # @param row_name [String] Label for the table row
  # @param column [Integer] The column index to pull (defaults to 1 which is
  #                         usually the school column)
  # @param conversion_method [Symbol] a method to call on the String in the
  #                                   table cell to get a result (default to_f)
  #
  # Not using ruby 2.1 so use this hack to get required keyword args
  def scrape_table_row(doc: doc, row_name: row_name, column: 1, conversion_method: :to_f)
    # lazy error handling here, just return nil if anything goes wrong
    # (if the table row isn't found, etc etc)
    begin
      doc.
        css("td").
        select{ |td| td.text.strip == row_name }.
        first.
        parent.
        css("td")[column].
        text.
        strip.
        send(conversion_method)
    rescue
      nil
    end
  end

  # Set a field only if the current value is nil.
  # This avoids overwriting manually entered fields.
  def set_field_if_blank(field, value)
    if @school.send(field).blank? && !value.nil?
      @school.update_attribute(field, value)
    end
  end
end
