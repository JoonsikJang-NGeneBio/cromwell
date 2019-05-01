package cloud.nio.impl.drs

import java.net.URI
import java.nio.channels.ReadableByteChannel

import cats.effect.IO
import cloud.nio.spi.{CloudNioFileProvider, CloudNioFileSystemProvider}
import com.google.auth.oauth2.OAuth2Credentials
import com.typesafe.config.Config
import org.apache.http.impl.client.HttpClientBuilder
import net.ceedubs.ficus.Ficus._
import scala.concurrent.duration.FiniteDuration


class DrsCloudNioFileSystemProvider(rootConfig: Config,
                                    authCredentials: OAuth2Credentials,
                                    httpClientBuilder: HttpClientBuilder,
                                    drsReadInterpreter: MarthaResponse => IO[ReadableByteChannel]) extends CloudNioFileSystemProvider {

  private lazy val marthaUri = rootConfig.getString("martha.url")
  private lazy val marthaRequestJsonTemplate = rootConfig.getString("martha.request.json-template")
  private lazy val drsConfig = DrsConfig(marthaUri, marthaRequestJsonTemplate)

  private lazy val accessTokenAcceptableTTL = rootConfig.as[FiniteDuration]("access-token-acceptable-ttl")

  lazy val drsPathResolver = DrsPathResolver(drsConfig, httpClientBuilder)

  override def config: Config = rootConfig

  override def fileProvider: CloudNioFileProvider = new DrsCloudNioFileProvider(getScheme, accessTokenAcceptableTTL, drsPathResolver, authCredentials, httpClientBuilder, drsReadInterpreter)

  override def isFatal(exception: Exception): Boolean = false

  override def isTransient(exception: Exception): Boolean = false

  override def getScheme: String = "dos"

  override def getHost(uriAsString: String): String = {
    require(uriAsString.startsWith(s"$getScheme://"), s"Scheme does not match $getScheme")

    /*
     * It's possible for DRS URIs to have no host, and even no authority.
     * In the case where URI parsing shows there is a host, use that.
     * In the case where host is null, try authority next and eventually fall back to an empty string.
     * In the cases where uri.getHost returns null, and there is an authority, use that, else use an empty string for host.
     * In some cases for a URI, the host name is null. For example, for DRS urls like 'dos://dg.123/123-123-123',
     * even though 'dg.123' is a valid host, somehow since it does not conform to URI's standards, uri.getHost returns null. In such
     * cases, authority is used instead of host.
     */
    val uri = new URI(uriAsString)
    val host = uri.getHost
    val hostOrAuthorityOrEmpty =
      if (host == null) {
        val authority = uri.getAuthority
        if (authority == null) { "" } else authority
      } else host

    hostOrAuthorityOrEmpty
  }
}
