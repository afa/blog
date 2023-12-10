class Link::PrepareReserved
  include Dry::Transaction

  step :take_list
  step :gen_forward
  step :gen_list

  private

  def take_list(max_num = 1000)
    l_c = Struct.new(:forwards, :gaps)
    list = l_c.new
    max = FastLink.order(Sequel.desc(:url_num)).first&.url_num || 0

  end

  def gen_forward(list)

  end

  def gen_list(list)

  end
end
