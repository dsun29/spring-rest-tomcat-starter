package edu.umc.sis.report.mainsub.controllers;

/**
 * Guitar Model Object.
 *
 * @author $(USER)
 * @see <a href="git.olemiss.edu">git.olemiss.edu</a>
 * @since 10/16/17
 */

import edu.umc.sis.jcojson2.JCoJSON2;
import edu.umc.sis.util.UMMCPropertyReader;
import org.springframework.http.CacheControl;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.xml.ws.Response;
import java.util.Properties;

@RestController
public class MainSubReportController {

    private static final String TOMCATCONTEXT = "ummcmainsub";
    private static Properties properties = new Properties();

    @RequestMapping("/")
    public String index(){

        try
        {


            UMMCPropertyReader reader = new UMMCPropertyReader();
            reader.setTomcatContext(TOMCATCONTEXT);
            properties = reader.readProperties();

            //retrieve open times, holds and other info from SAP
            JCoJSON2 jco = new JCoJSON2(properties.get("JCO_ASHOST").toString(), properties.get("JCO_SYSNR").toString(), properties.get("JCO_CLIENT").toString(), properties.get("JCO_USER").toString(), properties.get("JCO_PASSWD").toString(), "UMMCMAINSUB");

            jco.setFunction(properties.get("RFC_WRAPPER").toString());

            jco.setParameters("{}");

            String resultJson = jco.execute();


            return resultJson;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            String output = "{\"message\": \"" + e.toString() + "\"}";
            return output;
        }
    }
}
