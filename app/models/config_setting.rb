require 'yaml'

class ConfigSetting < ActiveRecord::Base
	validates_uniqueness_of :key
	validate :check_type_of_value, on: :update

	def check_type_of_value
		valid_types = ['String','Float','Fixnum','TrueClass','FalseClass']
		unless valid_types.include? YAML::load(value).class.name
			errors.add(:value, "Invalid data type for value!")
			self.destroy
			Rails.cache.delete(key)
		end
	end

	#get or set a variable with the variable as the called method
	def self.method_missing(method, *args)
		method_name = method.to_s
		super(method, *args)
	rescue NoMethodError
		#set a value for a variable
		if method_name =~ /=$/
			var_name = method_name.gsub('=', '')
			self[var_name] = args.first
		#retrieve a value
		else
			self[method_name]
		end
	end

	def self.[](key)
		key = key.to_s 
		if cache_val = Rails.cache.read(key)
			return cache_val
		end
		if record = find_by_key(key)
			value = YAML::load(record.value)
			Rails.cache.write(key, value)
			return value
		end
	end

	# save key value pair
	def self.[]=(key, value)
		key = key.to_s
		val = YAML::dump(value)
		record = find_or_create_by_key(key)
		record.update_attributes(value: val)
		Rails.cache.write(key, value)
	end

	# delete setting
	def self.delete(key)
		val = send("[]", key)
		record = find_by_key(key.to_s)
		record.destroy
		return val
	end

end
