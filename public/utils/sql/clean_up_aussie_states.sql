UPDATE places SET address = regexp_replace(address, '(new south wales)', 'NSW', 'i');
UPDATE places SET address = regexp_replace(address, '(victoria)', 'VIC', 'i');
UPDATE places SET address = regexp_replace(address, '(south australia)', 'SA', 'i') ;
UPDATE places SET address = regexp_replace(address, '(queensland)', 'QLD', 'i');
UPDATE places SET address = regexp_replace(address, '(western australia)', 'WA', 'i');
UPDATE places SET address = regexp_replace(address, '(northern territory)', 'NT', 'i');
UPDATE places SET address = regexp_replace(address, '(tasmania)', 'TAS', 'i');
UPDATE places SET address = regexp_replace(address, '(australian capital territory)', 'ACT', 'i');

UPDATE places SET state = regexp_replace(state, '(new south wales)', 'NSW', 'i');
UPDATE places SET state = regexp_replace(state, '(victoria)', 'VIC', 'i');
UPDATE places SET state = regexp_replace(state, '(south australia)', 'SA', 'i');
UPDATE places SET state = regexp_replace(state, '(queensland)', 'QLD', 'i');
UPDATE places SET state = regexp_replace(state, '(western australia)', 'WA', 'i');
UPDATE places SET state = regexp_replace(state, '(northern territory)', 'NT', 'i');
UPDATE places SET state = regexp_replace(state, '(tasmania)', 'TAS', 'i');
UPDATE places SET state = regexp_replace(state, '(australian capital territory)', 'ACT', 'i');

UPDATE places SET state = regexp_replace(state, '(new south wales)', 'NSW', 'i') where country_id=194;
UPDATE places SET state = regexp_replace(state, '(victoria)', 'VIC', 'i') where country_id=194;
UPDATE places SET state = regexp_replace(state, '(south australia)', 'SA', 'i') where country_id=194;
UPDATE places SET state = regexp_replace(state, '(queensland)', 'QLD', 'i') where country_id=194;
UPDATE places SET state = regexp_replace(state, '(western australia)', 'WA', 'i') where country_id=194;
UPDATE places SET state = regexp_replace(state, '(northern territory)', 'NT', 'i') where country_id=194;
UPDATE places SET state = regexp_replace(state, '(tasmania)', 'TAS', 'i') where country_id=194;
UPDATE places SET state = regexp_replace(state, '(australian capital territory)', 'ACT', 'i') where country_id=194;

UPDATE areas SET address = regexp_replace(address, '(new south wales)', 'NSW', 'i');
UPDATE areas SET address = regexp_replace(address, '(victoria)', 'VIC', 'i');
UPDATE areas SET address = regexp_replace(address, '(south australia)', 'SA', 'i');
UPDATE areas SET address = regexp_replace(address, '(queensland)', 'QLD', 'i');
UPDATE areas SET address = regexp_replace(address, '(western australia)', 'WA', 'i');
UPDATE areas SET address = regexp_replace(address, '(northern territory)', 'NT', 'i');
UPDATE areas SET address = regexp_replace(address, '(tasmania)', 'TAS', 'i');
UPDATE areas SET address = regexp_replace(address, '(australian capital territory)', 'ACT', 'i');

select address from places where state ilike '%south australia%';