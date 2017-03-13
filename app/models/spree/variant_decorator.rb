Spree::Variant.class_eval do
  enum maturity: { adult: 0, child: 1 }
  enum bed_type: { single: 0, twin: 1 }
end
