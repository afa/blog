class Link::PrepareReserved < BaseInteractor
  # нагенерить быстрых ссылок наперёд на по умолчанию тысячу или параметром позиций вперед, закрывая дырки в
  #  числах (url_num). первысмм шагом вытягиваем список
  #  умолчательно макснум ограничивает число сгенеренных ссылок, одновременно не генеря больше макснума вперед.
  #  сервис зовётся не только в фоне но и если сгенеренных не нашлось. возвращает саксес со списком ид нагенеренных

  option :max_num, default: 1000

  def call
    list = yield take_list
  end
  # step :take_list
  # step :gen_forward
  # step :gen_list

  private

  def take_list
    l_c = Struct.new(:forwards, :gaps)
    list = l_c.new
    max = FastLink.order(Sequel.desc(:url_num)).first&.url_num || 0
  end

  def gen_forward(list)
  end

  def gen_list(list)
  end
end
