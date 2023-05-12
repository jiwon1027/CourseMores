package com.moham.coursemores.service.impl;

import com.moham.coursemores.domain.Region;
import com.moham.coursemores.dto.region.GugunResDto;
import com.moham.coursemores.repository.RegionRepository;
import com.moham.coursemores.service.RegionService;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RegionServiceImpl implements RegionService {

    private final RegionRepository regionRepository;

    @Override
    @Transactional
    public void saveDummy() throws Exception {
        FileReader fr = new FileReader("src/main/resources/AdministrativeDistrict.csv");
        BufferedReader br = new BufferedReader(fr);
        br.readLine(); // 행정구역 분류가 저장되지 않도록 한 줄 버리기

        String data;
        while ((data = br.readLine()) != null) {
            String[] info = data.split(",");
            // [0] : 분류코드 // [1] : 대분류번호 // [2] : 대분류명 // [3] : 중분류번호 // [4] : 중분류명
            regionRepository.save(Region.builder()
                    .sido(info[2])
                    .gugun(info[4])
                    .build());
        }

    }

    @Override
    public List<String> getSidoList() {
        return regionRepository.getSidoList();
    }

    @Override
    public List<GugunResDto> getGugunList(String sido) {
        return regionRepository.findBySido(sido)
                .stream()
                .map(region -> GugunResDto.builder()
                        .gugun(region.getGugun())
                        .regionId(region.getId())
                        .build())
                .collect(Collectors.toList());
    }

}