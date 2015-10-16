# class Traversal
#   attr_reader :seen
#
#   def initialize
#     @pending = []
#     @seen = []
#   end
#
#
#
#   def go!
#     @pending.push (start_page)
#     while page = @pending.shift
#       visit page
#     end
#   end
#
#   def visit page
#     l = get page
#     @seen.push page
#     m.links.each do |l|
#       unless @seen.include?(l)
#         @pending.push(l)
#     if l.href== nil || l.href.include?("?") || l.href.include?("Policies") || l.text == "Articles" || l.text == "Status Articles" || l.text == "Browse articles by category"  || l.text == "Contact" || l.text == "Forums" || l.href.include?("talk")
#       next
#     elsif l.href.include?("Category") == false
#       next
#         end
#       end
#     end
