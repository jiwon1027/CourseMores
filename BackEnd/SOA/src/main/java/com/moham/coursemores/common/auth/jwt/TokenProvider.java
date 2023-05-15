package com.moham.coursemores.common.auth.jwt;

import com.moham.coursemores.common.exception.CustomErrorCode;
import com.moham.coursemores.common.exception.CustomException;
import com.moham.coursemores.common.util.OAuthProvider;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.Objects;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class TokenProvider {

    private final Key key;
    @Value("${token.authorities.key}")
    private static String AUTHORITIES_KEY;
    @Value("${token.access.expire}")
    private static long ACCESS_TOKEN_EXPIRE_TIME;

    public TokenProvider(@Value("${jwt.secret}") String secretKey) {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    public String generateAccessToken(String subject, OAuthProvider oAuthProvider) {
        long now = (new Date()).getTime();
        return Jwts.builder()
                .setSubject(subject)
                .claim(AUTHORITIES_KEY, oAuthProvider)
                .setExpiration(new Date(now + ACCESS_TOKEN_EXPIRE_TIME))
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }

    public Long extractMemberId(String accessToken) {
        Claims claims = parseClaims(accessToken);
        return Long.valueOf(Objects.requireNonNull(claims).getSubject());
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
        if (validate(accessToken)) {
            Claims claims = parseClaims(accessToken);
            Collection<? extends GrantedAuthority> authorities =
                    Arrays.stream(Objects.requireNonNull(claims).get(AUTHORITIES_KEY).toString().split(","))
                            .map(SimpleGrantedAuthority::new)
                            .collect(Collectors.toList());
            User principal = new User(claims.getSubject(), "", authorities);
            return new UsernamePasswordAuthenticationToken(principal, accessToken, authorities);
        } else {
            throw new CustomException(CustomErrorCode.TOKEN_NOT_VALID);
        }
    }

}