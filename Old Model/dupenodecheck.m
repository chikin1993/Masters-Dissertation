% A function to check if a given index would lead to a multiple edge,
% checks in both directions by calling the checking function twice
function dupe = dupenodecheck(index, ialpha, jalpha, i, list)
    
    % Call the duplicate function twice, with reversed order on alpha to
    % check for a duplicate edge
    dupe1 = dupenode(index, ialpha, jalpha, i, list);
    dupe2 = dupenode(index, jalpha, ialpha, i, list);
    dupe = and(dupe1, dupe2);

end