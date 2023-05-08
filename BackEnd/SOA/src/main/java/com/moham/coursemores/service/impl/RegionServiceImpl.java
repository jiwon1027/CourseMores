package com.moham.coursemores.service.impl;

import com.moham.coursemores.service.RegionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RegionServiceImpl implements RegionService {


}
