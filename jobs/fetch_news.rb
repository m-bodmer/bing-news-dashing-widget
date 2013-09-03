# Bing search wrapper gem: https://github.com/rcullito/searchbing
require 'searchbing'

# Get news for a certain topic
news_topic = '500px'
# Primary account key (string) which you can get from https://datamarket.azure.com/account
bing_account_key = 'uFNfmtWots8uX/yZoPie5Rqghqaje4OyACdhXGK4kGk'
# If you want to change the date format, just edit the strftime string below according to http://www.ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/DateTime.html
date_format = "%b. %d %Y at %l:%M%p"

SCHEDULER.every '3h', :first_in => 0 do |job|

    bing_news = Bing.new(bing_account_key, 3, 'News')
    news_results = bing_news.search(news_topic)

    # Format Bing news date result to be more readable
    if news_results
      news_results.select { |key|
        if key['Date']
          date = Time.parse key['Date']
          key['Date'].replace date.strftime(date_format)
        end
      }
      send_event('fetchNews', {newsItems: news_results, title: "News for: #{news_topic}"})
    else
      send_event('fetchNews', {newsItems: news_results, title: "No News for #{news_topic}"})
    end
end
