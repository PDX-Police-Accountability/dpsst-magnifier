Fabricator(:officer) do
  dpsst_identifier { sequence(:dpsst_identifier) { |i| i.to_s.rjust(5, '0') } }
end
