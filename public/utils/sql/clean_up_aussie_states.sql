UPDATE places SET address = regexp_replace(address, '(new south wales)', 'NSW', 'i') where country ilike 'australia';
UPDATE places SET address = regexp_replace(address, '(victoria)', 'VIC', 'i') where country ilike 'australia';
UPDATE places SET address = regexp_replace(address, '(south australia)', 'SA', 'i')  where country ilike 'australia';
UPDATE places SET address = regexp_replace(address, '(queensland)', 'QLD', 'i') where country ilike 'australia';
UPDATE places SET address = regexp_replace(address, '(western australia)', 'WA', 'i') where country ilike 'australia';
UPDATE places SET address = regexp_replace(address, '(northern territory)', 'NT', 'i') where country ilike 'australia';
UPDATE places SET address = regexp_replace(address, '(tasmania)', 'TAS', 'i') where country ilike 'australia';
UPDATE places SET address = regexp_replace(address, '(australian capital territory)', 'ACT', 'i') where country ilike 'australia';

UPDATE places SET state = regexp_replace(state, '(new south wales)', 'NSW', 'i') where country ilike 'australia';
UPDATE places SET state = regexp_replace(state, '(victoria)', 'VIC', 'i') where country ilike 'australia';
UPDATE places SET state = regexp_replace(state, '(south australia)', 'SA', 'i') where country ilike 'australia';
UPDATE places SET state = regexp_replace(state, '(queensland)', 'QLD', 'i') where country ilike 'australia';
UPDATE places SET state = regexp_replace(state, '(western australia)', 'WA', 'i') where country ilike 'australia';
UPDATE places SET state = regexp_replace(state, '(northern territory)', 'NT', 'i') where country ilike 'australia';
UPDATE places SET state = regexp_replace(state, '(tasmania)', 'TAS', 'i') where country ilike 'australia';
UPDATE places SET state = regexp_replace(state, '(australian capital territory)', 'ACT', 'i') where country ilike 'australia';

UPDATE areas SET address = regexp_replace(address, '(new south wales)', 'NSW', 'i') where country ilike 'australia';
UPDATE areas SET address = regexp_replace(address, '(victoria)', 'VIC', 'i') where country ilike 'australia';
UPDATE areas SET address = regexp_replace(address, '(south australia)', 'SA', 'i') where country ilike 'australia';
UPDATE areas SET address = regexp_replace(address, '(queensland)', 'QLD', 'i') where country ilike 'australia';
UPDATE areas SET address = regexp_replace(address, '(western australia)', 'WA', 'i') where country ilike 'australia';
UPDATE areas SET address = regexp_replace(address, '(northern territory)', 'NT', 'i') where country ilike 'australia';
UPDATE areas SET address = regexp_replace(address, '(tasmania)', 'TAS', 'i') where country ilike 'australia';
UPDATE areas SET address = regexp_replace(address, '(australian capital territory)', 'ACT', 'i') where country ilike 'australia';
