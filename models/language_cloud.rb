class LanguageCloud
  def self.map
    <<-JS
    function () {
      emit({language:this.language}, {count:1});
    }
    JS
  end

  def self.reduce
    <<-JS
    function (key, values) {
      var count = 0;
      values.forEach(function (v) {count += v.count;});
      return {count:count};
    }
    JS
  end

  def self.build
    Paste.collection.map_reduce(map, reduce, :out => "languageCloud")
  end
end
