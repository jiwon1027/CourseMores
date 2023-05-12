package com.moham.coursemores.service;

import com.moham.coursemores.dto.region.GugunResDto;
import java.util.List;

public interface RegionService {
    void saveDummy();
    List<String> getSidoList();
    List<GugunResDto> getGugunList(String sido);
}