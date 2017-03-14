Spree::Variant.class_eval do
  enum maturity: { adult: 0, child: 1 } unless instance_methods.include? :maturity
  enum bed_type: { single: 0, twin: 1 } unless instance_methods.include? :bed_type
end
