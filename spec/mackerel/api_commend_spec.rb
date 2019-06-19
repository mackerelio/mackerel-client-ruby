RSpec.describe Mackerel::ApiCommand do
  let(:api_key) { "xxxxxxxx" }
  let(:command) { Mackerel::ApiCommand.new(:get, "/api/v0/services", api_key) }

  describe "#execute" do
    let(:api_path) { "/api/v0/services" }

    let(:test_client) {
      Faraday.new do |builder|
        builder.response :raise_error
        builder.adapter :test do |stubs|
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:services) {
      {
        "services" => [
          {
            "name" => "Web",
            "memo" => "store",
            "roles" => [
              "normal role",
              "special role"
            ]
          },
          {
             "name" => "Web",
             "memo" => "store",
             "roles" => [
               "a role",
               "the role"
             ]
          }
        ]
      }
    }

    context "when success" do
      let(:stubbed_response) {
        [
          200,
          {},
          JSON.dump(services)
        ]
      }

      it {
        expect(command.execute(test_client)).to eq(services)
      }
    end

    context "when 404 Not Found" do
      let(:stubbed_response) {
        [
          404,
          {},
          JSON.dump({"error" => "Host Not Found."})
        ]
      }

      it {
        expect { command.execute(test_client) }.to raise_error Mackerel::Error, "GET /api/v0/services failed: 404 Host Not Found."
      }
    end

    context "when 401 Unauthorized" do
      let(:stubbed_response) {
        [
          401,
          {},
          JSON.dump({ "error" => "Authentication failed. Please try with valid Api Key." })
        ]
      }

      it {
        expect { command.execute(test_client) }.to raise_error Mackerel::Error, "GET /api/v0/services failed: 401 Authentication failed. Please try with valid Api Key."
      }
    end
  end
end
