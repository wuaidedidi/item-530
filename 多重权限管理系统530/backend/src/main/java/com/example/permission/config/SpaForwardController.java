package com.example.permission.config;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Forwards Vue Router history-mode pages to the bundled frontend entry.
 */
@Controller
public class SpaForwardController {

    @RequestMapping(value = {
        "/login",
        "/dashboard",
        "/profile",
        "/system/{path:[^\\.]*}",
        "/system/**/{path:[^\\.]*}"
    })
    public String forward() {
        return "forward:/index.html";
    }
}
