class ApplicationView < Dry::View
  config.paths = File.join(__dir__, '../templates')
  config.part_namespace = Parts
  config.layout = 'application'
end
