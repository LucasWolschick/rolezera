module UserHelper
  def format_phone(phone)
    Phonelib.parse(phone).international
  end
end
