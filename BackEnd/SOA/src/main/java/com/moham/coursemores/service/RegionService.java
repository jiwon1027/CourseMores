package com.moham.coursemores.service;

import com.moham.coursemores.dto.region.GugunResDto;

import java.util.List;

public interface RegionService {
    void saveDummy()  throws Exception;
    List<String> getRegionBigList();
    List<GugunResDto> getGugunList(String sido);
}