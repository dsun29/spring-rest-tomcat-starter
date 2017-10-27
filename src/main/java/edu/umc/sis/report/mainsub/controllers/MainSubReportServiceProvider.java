package edu.umc.sis.report.mainsub.controllers;

import edu.umc.sis.jcojson2.JCoJSON2;
import edu.umc.sis.util.UMMCPropertyReader;

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

@Path("/")
public class MainSubReportServiceProvider {
    private static final String TOMCATCONTEXT = "ummcmainsub";
    private static Properties properties = new Properties();

    @GET
    @Path("/init")
    public Response get_index(@HeaderParam("user") String user, @Context HttpServletRequest request)
    {
        try
        {
            UMMCPropertyReader reader = new UMMCPropertyReader();
            reader.setTomcatContext(TOMCATCONTEXT);
            properties = reader.readProperties();

            String host = properties.get("JCO_ASHOST").toString();
            String sysnr = properties.get("JCO_SYSNR").toString();
            String client = properties.get("JCO_CLIENT").toString();

            JCoJSON2 jco = new JCoJSON2(host, sysnr, client,
                    properties.get("JCO_USER").toString(), properties.get("JCO_PASSWD").toString(), "UMMCMAINSUB");

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

    @POST
    @Path("/search")
    public Response search(@HeaderParam("user") String user, @FormParam("parameters") String parameters, @Context HttpServletRequest request)
    {
        try
        {
            UMMCPropertyReader reader = new UMMCPropertyReader();
            reader.setTomcatContext(TOMCATCONTEXT);
            properties = reader.readProperties();

            String host = properties.get("JCO_ASHOST").toString();
            String sysnr = properties.get("JCO_SYSNR").toString();
            String client = properties.get("JCO_CLIENT").toString();

            JCoJSON2 jco = new JCoJSON2(host, sysnr, client,
                    properties.get("JCO_USER").toString(), properties.get("JCO_PASSWD").toString(), "UMMCMAINSUB");

            jco.setFunction(properties.get("RFC_WRAPPER").toString());
            jco.setParameters(parameters);

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


}
