import React from "react";
import BannerBackground from "../Assets/home-banner-background.png";
import Google from "../Assets/google.png";
import Navbar from "./Navbar";
import Cosmos from "../Assets/cosmos.png";
import { BrowserRouter as Router, Link, Route, Routes } from "react-router-dom";

const Home = () => {
  return (
    <div className="home-container">
      <Navbar />
      <div className="home-banner-container">
        <div className="home-bannerImage-container">
          <img src={BannerBackground} alt="" />
        </div>

        <div className="home-text-section">
          <h1 className="primary-heading">자신의 코스를 만들고,</h1>
          <h1 className="primary-heading">다른 사람과 함께 공유하세요!</h1>
          <p className="primary-text">
            데이트 코스, 놀이 코스, 등산 코스 등 여러 종류의 코스를 직접
            구성하고 남들과 공유할 수 있는 SNS 플랫폼
          </p>
          <a href="https://play.google.com/store/apps/details?id=com.moham.coursemores">
            <img src={Google} alt="" width="300px" />
          </a>{" "}
          <div style={{ marginBottom: "20px" }}></div>{" "}
          {/* 간격을 조정하는 div 요소 */}
          <Link to="/policy">개인정보 처리방침</Link>
        </div>

        <div className="home-image-section">
          <img src={Cosmos} alt="" />
        </div>
      </div>
    </div>
  );
};

export default Home;
