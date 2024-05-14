function m_end_point = func_find_another_endpoint(m_start_point, segIndex, cell_1)
segWhole = cell_1{2, segIndex};
if m_start_point == segWhole(1,:)
    m_end_point = segWhole(end,:);
else
    m_end_point = segWhole(1,:);
end

