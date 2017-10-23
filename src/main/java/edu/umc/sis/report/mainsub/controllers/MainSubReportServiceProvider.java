package edu.umc.sis.report.mainsub.controllers;

import edu.umc.sis.jcojson2.JCoJSON2;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.DELETE;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.CacheControl;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;


/**
 * Guitar Model Object.
 *
 * @author $(USER)
 * @see <a href="git.olemiss.edu">git.olemiss.edu</a>
 * @since 10/23/17
 */
public class MainSubReportServiceProvider {
    private static final String PROPERTIES_FILE = "ummcmainsub.properties";
    private static Properties properties = new Properties();

    @GET
    public Response get_index(@HeaderParam("user") String user, @QueryParam("uuid") String uuid, @Context HttpServletRequest request)
    {
        try
        {
            readProperties();

            JCoJSON2 jco = new JCoJSON2(properties.get("JCO_ASHOST").toString(), properties.get("JCO_SYSNR").toString(), properties.get("JCO_CLIENT").toString(), properties.get("JCO_USER").toString(), properties.get("JCO_PASSWD").toString(), "UMMCMODULEREQUEST");

            jco.setFunction(properties.get("RFC_WRAPPER").toString());
            jco.setParameters("{\"IV_REQUEST\":\"INIT\", \"IV_USER\": \"" + user + "\"}");

            String resultJson = jco.execute();

            CacheControl control = new CacheControl();
            control.setNoCache(true);
            return Response.status(200).entity(resultJson).cacheControl(control).build();
        }
        catch (Exception e)
        {
            e.printStackTrace();
            String output = "{\"message\": \"" + e.toString() + "\"}";
            return Response.status(500).entity(output).build();
        }
    }

    private Properties readProperties()
            throws IOException
    {
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream(PROPERTIES_FILE);
        if (inputStream != null) {
            try
            {
                properties.load(inputStream);
            }
            catch (IOException e)
            {
                e.printStackTrace();
                throw e;
            }
        }
        return properties;
    }

}
