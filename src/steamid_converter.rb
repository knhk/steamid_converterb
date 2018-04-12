class SteamidConverter
  CONVERT_BASE_NUM = 76561197960265728

  REGEX_STEAM_ID_64 = /^[0-9]{17}$/
  REGEX_STEAM_ID = /^STEAM_[0-5]:[01]:\d+$/
  REGEX_STEAM_ID_3 = /^\[U:1:[0-9]+\]$/

  STEAM_ID_64 = 'STEAM_ID_64'
  STEAM_ID = 'STEAM_ID'
  STEAM_ID_3 = 'STEAM_ID_3'

  STEAM_PROFILE_URL = 'https://steamcommunity.com/profiles/'

  def self.get_steam_id_64(id)
    if id.nil? || !id.instance_of?(String)
      return false
    elsif self.is_steam_id_64 id
      return id
    elsif self.is_steam_id_3 id
      id = self.convert_3_to_id id
    elsif !self.is_steam_id id
      return false
    end

    split = id.split(':')
    v = CONVERT_BASE_NUM
    z = split[2].to_i
    y = split[1].to_i

    ((z * 2) + v + y).to_s
  end

  def self.get_steam_id(id64)
    if id64.nil? || !id64.instance_of?(String)
      false
    elsif self.is_steam_id id64
      return id64
    elsif self.is_steam_id_3 id64
      return self.convert_3_to_id id64
    elsif !self.is_steam_id_64 id64
      false
    end

    v = CONVERT_BASE_NUM
    w = id64.to_i
    y = w % 2
    w2 = w - y - v

    if w2 < 1
      return false
    end

    'STEAM_0:' + y + ':' + (w2 / 2)
  end

  def self.get_steam_id_3(id)
    if id.nil? || !id.instance_of?(String)
      false
    elsif self.is_steam_id_3 id
      return id
    elsif self.is_steam_id_64 id
      id = self.get_steam_id id
    elsif !self.is_steam_id id
      false
    end

    split = id.split(':')
    'U:1:' + (split[1].floor + split[2].floor * 2).to_s
  end

  def self.is_steam_id_64(id)
    if id.nil? || !id.instance_of?(String)
      false
    else
      REGEX_STEAM_ID_64 === id
    end
  end

  def self.is_steam_id(id)
    if id.nil? || !id.instance_of?(String)
      false
    else
      REGEX_STEAM_ID === id
    end
  end

  def self.is_steam_id_3(id)
    if id.nil? || !id.instance_of?(String)
      false
    else
      REGEX_STEAM_ID_3 === id
    end
  end

  def self.get_profile_url(id)
    if id.nil? || !id.instance_of?(String)
      return false
    elsif !self.is_steam_id_64 id
      id = self.get_steam_id_64 id
    end

    if id
      STEAM_PROFILE_URL + id
    else
      false
    end
  end

  private
    def convert_3_to_id(id)
      if self.is_steam_id_3 id
        split = id.split(':')
        tmp = split[2][0, split[2].length - 1]
        z = (tmp / 2).floor
        y = tmp % 2

        'STEAM_0:' + y.to_s + ':' + z.to_s
      else
        false
      end
    end
end
