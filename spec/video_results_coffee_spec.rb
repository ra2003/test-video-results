describe "SerpApi Video Results" do

  before(:all) do
    @host = 'https://serpapi.com'
    if ENV['API_KEY']
       @host = 'http://localhost:3000'
       @url_api_key = '&api_key=' + ENV['API_KEY']
    else
      @url_api_key = ''
    end
 end

  describe "desktop: video results for Coffee" do

    before :all do
      @response = HTTP.get @host + '/search.json?q=Coffee&tbm=vid&location=Dallas&hl=en&gl=us&device=desktop&source=test' + @url_api_key
      @json = @response.parse
    end

    it "returns http success" do
      expect(@response.code).to be(200)
    end

    it "contains video results array" do
      expect(@json["video_results"]).to be_an(Array)
    end

    it 'contains 10 video in the result' do
      expect(@json['video_results'].size).to eq(10)
    end

    describe "check video field are present for the first result" do

      before :all do
        @first_result = @json["video_results"][0]
      end

      %w(position title link displayed_link thumbnail snippet rich_snippet).each do |field|
        it "#{field}" do
           expect(@json["video_results"][0][field]).not_to be_nil
        end
      end

      it "title" do
        expect(@first_result["title"]).to_not be_empty
      end
    end
  end

  describe "mobile: video results for Coffee" do

    before :all do
      @response = HTTP.get @host + '/search.json?q=Coffee&tbm=vid&location=Dallas&hl=en&gl=us&device=mobile&source=test' + @url_api_key
      @json = @response.parse
      File.write('cache.json', JSON.pretty_generate(@json))
    end

    it "returns http success" do
      expect(@response.code).to be(200)
    end

    it "contains video results array" do
      expect(@json["video_results"]).to be_an(Array)
    end

    it 'contains 10 video in the result' do
      expect(@json['video_results'].size).to eq(10)
    end

    describe "check if field is present for the first result: " do

      before :all do
        @first_result = @json["video_results"][0]
      end

      %w(position title link thumbnail).each do |field|
        10.times do |index|
          it "json['video_results'][#{index}]#{field}" do
            expect(@json["video_results"][0][field]).not_to be_nil
          end
        end
      end

      it "title" do
        expect(@first_result["title"]).to_not be_empty
      end
    end
  end
end
