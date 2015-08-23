require "open-uri"
require "nokogiri"

class DataScraper
  def initialize(school)
    @school = school
    @id = school.org_id_number
  end

  def scrape
    return if @id.nil?

    scrape_general
    scrape_grad_rates
    scrape_postgrad_intentions

    @school.save!
  end

  def scrape_general
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/profiles/general.aspx?topNavId=1&orgcode=#{@id}&orgtypecode=6&"))

    # scrape address
    doc.css("#whiteboxRight tr").each do |row|
      columns = row.css("td")
      if columns.size >= 2
        case columns.first.text.strip
        when "Mailing Address:"
          set_field_if_nil(:address, columns[1].text.strip)
        when "Phone:"
          set_field_if_nil(:phone, columns[1].text.strip)
        end
      end
    end
  end

  def scrape_grad_rates
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/grad/grad_report.aspx?orgcode=#{@id}&orgtypecode=6&"))

    grad_rates_tr = doc.css("td").select{ |td| td.text == "4-Year Graduation Rate  (2014)" }.first.parent.parent.css("tr.ccc")
    rates = grad_rates_tr.css("td").map{ |td| td.text.strip.to_f }

    set_field_if_nil(:four_yr_graduated, rates[2])
    set_field_if_nil(:four_yr_still_in_school, rates[3])
    set_field_if_nil(:four_yr_ged, rates[5])
    set_field_if_nil(:four_yr_dropped_out, rates[6])
  end

  def scrape_postgrad_intentions
    doc = Nokogiri::HTML(open("http://profiles.doe.mass.edu/profiles/student.aspx?orgcode=#{@id}&orgtypecode=6&leftNavId=307&"))

    four_year_private = process_postgrad_row(doc, "4-Year Private College")
    four_year_public = process_postgrad_row(doc, "4-Year Public College")
    two_year_private = process_postgrad_row(doc, "2-Year Private College")
    two_year_public = process_postgrad_row(doc, "2-Year Public College")
    unknown = process_postgrad_row(doc, "Unknown")

    if four_year_private && four_year_public
      set_field_if_nil(:post_grad_four_yr_college, four_year_private + four_year_public)
    end

    if two_year_private && two_year_public
      set_field_if_nil(:post_grad_two_yr_college, two_year_private + two_year_public)
    end

    set_field_if_nil(:post_grad_unknown, unknown)
  end

  # Take in a postgrad intentions page and a row title.
  # Return the first number in the row, which corresponds to school number.
  def process_postgrad_row(doc, row_name)
    begin
      doc.
        css("td").
        select{ |td| td.text.strip == row_name }.
        first.
        parent.
        css("td")[1].
        text.
        strip.
        to_f
   rescue
    nil
   end
  end

  # Set a field only if the current value is nil.
  # This avoids overwriting manually entered fields.
  def set_field_if_nil(field, value)
    if @school.send(field).nil? && !value.nil?
      @school.update_attribute(field, value)
    end
  end

  # For all schools in the db, pull newest data from the Mass DESE site
  def self.scrape_all
    School.all.each do |school|
      DataScraper.new(school).scrape
    end
  end
end