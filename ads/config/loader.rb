# frozen_string_literal: true

loader = Zeitwerk::Loader.new
%i[models serializers services helpers].each do |dir|
  loader.push_dir [File.expand_path('..', __dir__), dir].join('/')
end
loader.setup
