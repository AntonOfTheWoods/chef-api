module ChefAPI
  class Resource::DataBagItem < Resource::Base
    collection_path '/data/:bag'

    schema do
      attribute :id,   type: String, primary: true, required: true
      attribute :data, type: Hash,   default: {}
    end

    class << self
      def from_file(path, bag = File.basename(File.dirname(path)))
        id, contents = Util.safe_read(path)
        data = JSON.parse(contents)
        data[:id] = id

        bag = bag.is_a?(DataBag) ? bag : DataBag.new(name: bag)

        new(data, { bag: bag.name }, bag)
      end
    end

    attr_reader :bag

    #
    # Override the initialize method to move any attributes into the +data+
    # hash.
    #
    def initialize(attributes = {}, prefix = {}, bag = nil)
      @bag = bag || DataBag.fetch(prefix[:bag])

      id = attributes.delete(:id) || attributes.delete('id')
      super({ id: id, data: attributes }, prefix)
    end
  end
end
