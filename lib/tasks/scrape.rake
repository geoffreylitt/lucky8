desc "Scrape data for all schools"
task scrape: :environment do
  DataScraper.scrape_all
end
