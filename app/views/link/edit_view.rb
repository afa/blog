module Link
  class EditView < ApplicationView
    config.template = 'links/edit'

    expose :link
  end
end
