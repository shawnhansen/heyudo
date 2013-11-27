class Tag < ActiveRecord::Base
  BLACKLIST = ["a", "and", "for", "has", "i", "if", "is", "my", "need", "needed", "or", "on", 
                  "the", "then", "this", "week", "weekly", "when", "which", "who", "whom", ]
  def self.collect_tags
    @clear_tags = Tag.find(:all)
    @clear_tags.each{|@clear_tag|@clear_tag.update_attribute("num", 0)}
    # @blacklist = ["a", "and", "for", "has", "i", "if", "my", "need", "needed", "or", "on", 
                 # "the", "then", "week", "weekly", "when", "which", "who", "whom", ]
    @posts = Post.find(:all,
                       :conditions => ['end_date >= :end_date',
                                        {:end_date => Time.now}])
    unless @posts.empty?
    @posts.map{|@post|@titles = @titles.to_s + @post.title.downcase.to_s + ' '}
    @tags = @titles.scan(/\w+/)
    @tags = @tags - BLACKLIST
    @tags.each{|@tag|@tag_check = Tag.find(:first, 
                                           :conditions => ['(name) = :name', 
                                              {:name => @tag.to_s}])
        if @tag_check.nil?
        @tag_new = Tag.new("name" => "#{@tag.to_s}", "num" => 1)
        @tag_new.save
        else
        @tag_num = @tag_check.num.to_i
        @tag_check.update_attribute("num", @tag_num + 1)
        end}
     end
    
    
  end

end
