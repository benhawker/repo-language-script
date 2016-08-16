require 'spec_helper'

describe Client do
  let(:login) { "benhawker" }
  let(:client) { described_class.new(login) }

  describe "#favorite" do
    context "when given a valid user with a clear favorite" do
      before do
        allow(client).to receive(:get_repositories).and_return ([{"language"=>"Ruby"}, {"language"=>"Ruby"}])
      end

      it "returns the given users most used language" do
        expect(STDOUT).to receive(:puts).with("benhawker's favorite language seems to be Ruby.")
        client.favorite
      end
    end

    context "when given a valid user with a equal favorites" do
      before do
        allow(client).to receive(:get_repositories).and_return ([{"language"=>"Ruby"}, {"language"=>"Ruby"}, {"language"=>"Go"}, {"language"=>"Go"}])
      end

      it "returns the multiple languages if are multiple with the top count" do
        expect(STDOUT).to receive(:puts).with("benhawker's favorite language seems to be Ruby and Go.")
        client.favorite
      end
    end

    context "when rate limited" do
      let(:error_message) { "Your IP has been rate limited by Github, please try again later." }

      before do
        allow_any_instance_of(described_class).to receive(:favorite).and_raise (error_message)
      end

      it "raises an error" do
        expect { client.favorite }.to raise_error (error_message)
      end
    end

    context "when the user requested is not a valid Github user" do
      let(:error_message) { "This user is not found. Please check you have a correct Github username." }

      before do
        allow_any_instance_of(described_class).to receive(:favorite).and_raise (error_message)
      end

      it "raises an error" do
        expect { described_class.new("does_not_exist").favorite }.to raise_error (error_message)
      end
    end
  end
end