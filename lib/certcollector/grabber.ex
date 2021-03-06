defmodule Certcollector.Grabber do
  def get_cert(host) do
    with charlist <- to_charlist(host),
         :ok <- :ssl.start,
         {:ok, socket} <- :ssl.connect(charlist, 443, [], 10000),
         {:ok, cert} <- :ssl.peercert(socket),
         :ok <- :ssl.close(socket),
         do: cert
  end
end