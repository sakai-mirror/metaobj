package org.sakaiproject.spring.util;

import java.util.Locale;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.sakaiproject.util.ResourceLoader;
import org.springframework.web.servlet.LocaleResolver;

public class SakaiLocaleResolver implements LocaleResolver {
    //Shared ResourceLoader -- it is thread-safe with default constructor
    private static ResourceLoader loader = new ResourceLoader();

    public Locale resolveLocale(HttpServletRequest request) {
        Locale userOrSystem = loader.getLocale();
        return userOrSystem;
    }

    public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {
        throw new UnsupportedOperationException();
    }
}

