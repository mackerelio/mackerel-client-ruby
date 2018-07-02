describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#post_notification_group' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post(api_path) { stubbed_response }
        end
      end
    }

    let(:api_path) { '/api/v0/notification-groups' }

    let(:notificationGroupId) { '123abEFabcd' }
    let(:notificationGroup) {
      {
        "id" => "270DgxukABC",
        "name" => "Example notification group",
        "notificationLevel" => "all",
        "childNotificationGroupIds" => [],
        "childChannelIds" => [
          "2vh7AZ21abc"
        ],
        "monitors" => [
          {
            "id" => "2qtozU21abc",
            "skipDefault" => false
          }
        ],
        "services" => [
          {
            "name" => "Example-Service-1"
          },
          {
            "name" => "Example-Service-2"
          }
        ]
      }
    }

    let(:response_object) {
       notificationGroup.merge({'id' => notificationGroupId})
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post notification groups" do
      expect(client.post_notification_group(notificationGroup).to_h).to eq(response_object)
    end
  end



  describe '#get_notification_groups' do

    let(:api_path) { "/api/v0/notification-groups" }
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:notificationGroups) { 
      {
        "notificationGroups" => [
          {
            "id" => "270DgxukABC",
            "name" => "Example notification group",
            "notificationLevel" => "all",
            "childNotificationGroupIds" => [],
            "childChannelIds" => [
              "2vh7AZ21abc"
            ],
            "monitors" => [
              {
                "id" => "2qtozU21abc",
                "skipDefault" => false
              }
            ],
            "services" => [
              {
                "name" => "Example-Service-1"
              },
              {
                "name" => "Example-Service-2"
              }
            ]
          },
          {
            "id" => "162DhijkABC",
            "name" => "Example notification group2",
            "notificationLevel" => "all",
            "childNotificationGroupIds" => [],
            "childChannelIds" => [
              "3vh7AZ21def"
            ],
            "monitors" => [
              {
                "id" => "3vh7AZ21def",
                "skipDefault" => false
              }
            ],
            "services" => [
              {
                "name" => "Example-Service-1"
              },
              {
                "name" => "Example-Service-2"
              }
            ]
          }
        ]
      }
    }

    let(:response_object) {
      notificationGroups
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get notification groups" do
      expect(client.get_notification_groups().map(&:to_h)).to eq(notificationGroups['notificationGroups'])
    end
  end

  describe '#update_notification_group' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.put(api_path) { stubbed_response }
        end
      end
    }

    let(:api_path) { "/api/v0/notification-groups/#{notificationGroupId}"}
    let(:notificationGroupId) { '123abEFabcd' }
    let(:notificationGroup) {
      {
        "id" => "270DgxukABC",
        "name" => "Example notification group",
        "notificationLevel" => "all",
        "childNotificationGroupIds" => [],
        "childChannelIds" => [
          "2vh7AZ21abc"
        ],
        "monitors" => [
          {
            "id" => "2qtozU21abc",
            "skipDefault" => false
          }
        ],
        "services" => [
          {
            "name" => "Example-Service-1"
          },
          {
            "name" => "Example-Service-2"
          }
        ]
      }
    }


    let(:response_object) {
      notificationGroup.merge({ "id" => notificationGroupId })
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully update notification group" do
      expect(client.update_notification_group(notificationGroupId, notificationGroup).to_h ).to eq(notificationGroup.merge({"id" => notificationGroupId}))
    end
  end


  describe '#delete_notification_group' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.delete(api_path) { stubbed_response }
        end
      end
    }

    let(:api_path) { "/api/v0/notification-groups/#{notificationGroupId}"}
    let(:notificationGroupId) { '123abEFabcd' }
    let(:notificationGroup) {
      {
        "id" => "270DgxukABC",
        "name" => "Example notification group",
        "notificationLevel" => "all",
        "childNotificationGroupIds" => [],
        "childChannelIds" => [
          "2vh7AZ21abc"
        ],
        "monitors" => [
          {
            "id" => "2qtozU21abc",
            "skipDefault" => false
          }
        ],
        "services" => [
          {
            "name" => "Example-Service-1"
          },
          {
            "name" => "Example-Service-2"
          }
        ]
      }
    }

    let(:response_object) {
      notificationGroup.merge({ "id" => notificationGroupId })
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully delete notification group" do
      expect(client.delete_notification_group(notificationGroupId).to_h ).to eq(notificationGroup.merge({"id" => notificationGroupId}))
    end
  end


end
