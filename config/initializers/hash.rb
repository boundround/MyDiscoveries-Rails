# class Hash

# 	alias :__fetch :[]

# 	def traverse(*path)
# 		path.inject(self) {|me,item| me.__fetch(item) || break }
# 	end

# 	def [](*args)
# 		(args.length > 1) ? traverse(*args) : __fetch(*args)
# 	end

# end


class Hash

	alias :__fetch :[]

	def traverse(*path)
		path.inject(self) {|me,item| 
			unless me.instance_of? self.class
				break 
			end
			me.__fetch(item) 
		}
	end

	def [](*args)
		(args.length > 1) ? traverse(*args) : __fetch(*args)
	end

end