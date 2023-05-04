package com.moham.coursemores.common.auth.jwt;

import com.moham.coursemores.common.util.OAuthProvider;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.stream.Collectors;

@Slf4j
@Component
public class TokenProvider {

//    private static final String AUTHORITIES_KEY = "auth";
    private static final String AUTHORITIES_KEY = "provider";
    private static final String BEARER_TYPE = "Bearer";
    private static final long ACCESS_TOKEN_EXPIRE_TIME = 1000 * 60 * 30;            // 30분
    private static final long REFRESH_TOKEN_EXPIRE_TIME = 1000 * 60 * 60 * 24 * 1;  // 1일

    private final Key key;

    public TokenProvider(@Value("${jwt.secret}") String secretKey) {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    public String generateAccessToken(String subject, OAuthProvider oAuthProvider) {
        long now = (new Date()).getTime();
        Date accessTokenExpiresIn = new Date(now + ACCESS_TOKEN_EXPIRE_TIME);
        return Jwts.builder()
                .setSubject(subject)
                .claim(AUTHORITIES_KEY, oAuthProvider)
                .setExpiration(accessTokenExpiresIn)
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }

    public String generateRefreshToken() {
        long now = (new Date()).getTime();
        // Refresh Token 생성
        return Jwts.builder()
                .setExpiration(new Date(now + REFRESH_TOKEN_EXPIRE_TIME))
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }

    public Long extractMemberId(String accessToken) {
        Claims claims = parseClaims(accessToken);
        return Long.valueOf(claims.getSubject());
    }

    public boolean validate(String token) { // AccessToken(AppToken) 유효한지 체크
        return this.parseClaims(token) != null;
    }

    private Claims parseClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (SecurityException e) {
            log.warn("Invalid JWT signature.");
        } catch (MalformedJwtException e) {
            log.warn("Invalid JWT token.");
            // 처음 로그인(/auth/kakao, /auth/google) 시,
            // AccessToken(AppToken) 없이 접근해도 token validate을 체크하기 때문에 exception 터트리지 않고 catch합니다.
        } catch (ExpiredJwtException e) {
            log.warn("Expired JWT token.");
        } catch (UnsupportedJwtException e) {
            log.warn("Unsupported JWT token.");
        } catch (IllegalArgumentException e) {
            log.warn("JWT token compact of handler are invalid.");
        }
        return null;
    }

    public Authentication getAuthentication(String accessToken) {

        if(validate(accessToken)) {

            Claims claims = parseClaims(accessToken);
            Collection<? extends GrantedAuthority> authorities =
                    Arrays.stream(claims.get(AUTHORITIES_KEY).toString().split(","))
//                    Arrays.stream(new String[]{claims.get(AUTHORITIES_KEY).toString()})
                            .map(SimpleGrantedAuthority::new)
                            .collect(Collectors.toList());

            User principal = new User(claims.getSubject(), "", authorities);
            // 사실상 principal에 저장되는 값은 socialId값과 role뿐(소셜 로그인만 사용하여 password 저장하지 않아 ""로 넣음)
            return new UsernamePasswordAuthenticationToken(principal, accessToken, authorities);
        } else {
            throw new RuntimeException("해당 토큰은 권한 정보가 없습니다.");
        }
    }

//
//    public Long getExpiration(){
//        return REFRESH_TOKEN_EXPIRE_TIME;
//    }
//
//    public String generateAccessTokenV1(Authentication authentication) {
//        // 권한들 가져오기
//        String authorities = authentication.getAuthorities().stream()
//                .map(GrantedAuthority::getAuthority)
//                .collect(Collectors.joining(","));
//
//        long now = (new Date()).getTime();
//
//        // Access Token 생성
//        Date accessTokenExpiresIn = new Date(now + ACCESS_TOKEN_EXPIRE_TIME);
//        String accessToken = Jwts.builder()
//                .setSubject(authentication.getName())       // payload "sub": "name" -> ##String id##
//                .claim(AUTHORITIES_KEY, authorities)        // payload "auth": "ROLE_USER"
//                .setExpiration(accessTokenExpiresIn)        // payload "exp": 1516239022 (예시)
//                .signWith(key, SignatureAlgorithm.HS512)    // header "alg": "HS512"
//                .compact();
//
//        return accessToken;
//    }
//
//    public String generateRefreshToken() {
//        long now = (new Date()).getTime();
//
//        // Refresh Token 생성
//        String refreshToken = Jwts.builder()
//                .setExpiration(new Date(now + REFRESH_TOKEN_EXPIRE_TIME))
//                .signWith(key, SignatureAlgorithm.HS512)
//                .compact();
//
//        return refreshToken;
//    }
//
//    public Authentication getAuthentication(String accessToken) {
//        // 토큰 복호화
//        Claims claims = parseClaims(accessToken);
//
//        if (claims.get(AUTHORITIES_KEY) == null) {
//            throw new RuntimeException("권한 정보가 없는 토큰입니다.");
//        }
//
//        // 클레임에서 권한 정보 가져오기
//        Collection<? extends GrantedAuthority> authorities =
//                Arrays.stream(claims.get(AUTHORITIES_KEY).toString().split(","))
////                Arrays.stream(new String[]{claims.get(AUTHORITIES_KEY).toString()})
//                        .map(SimpleGrantedAuthority::new)
//                        .collect(Collectors.toList());
//
//        // UserDetails 객체를 만들어서 Authentication 리턴
//        UserDetails principal = new User(claims.getSubject(), "", authorities);
//
//        return new UsernamePasswordAuthenticationToken(principal, "", authorities);
//    }
//
//    public boolean validateToken(String token) {
//        try {
//            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
//            return true;
//        } catch (io.jsonwebtoken.security.SecurityException | MalformedJwtException e) {
//            log.warn("잘못된 JWT 서명입니다.");
//        } catch (ExpiredJwtException e) {
//            log.warn("만료된 JWT 토큰입니다.");
//        } catch (UnsupportedJwtException e) {
//            log.warn("지원되지 않는 JWT 토큰입니다.");
//        } catch (IllegalArgumentException e) {
//            log.warn("JWT 토큰이 잘못되었습니다.");
//        }
//        return false;
//    }
//
//    private Claims parseClaims(String accessToken) {
//        try {
//            return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(accessToken).getBody();
//        } catch (ExpiredJwtException e) {
//            log.warn("[parseClaims] ExpiredJwtException 에러가 났습니다. {}, {}",e.getClaims(),e.getMessage());
//            return e.getClaims();
//        }
//    }
}