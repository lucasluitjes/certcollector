defmodule Certcollector do
  def get_cert(host) do
    with charlist <- to_charlist(host),
         :ok <- :ssl.start,
         {:ok, socket} <- :ssl.connect(charlist, 443, [], 10000),
         {:ok, cert} <- :ssl.peercert(socket),
         :ok <- :ssl.close(socket),
         do: :public_key.pkix_decode_cert(cert, :otp)
  end

  def to_json_safe(cert) when is_tuple(cert) do
    Tuple.to_list(cert) |> to_json_safe
  end

  def to_json_safe(cert) when is_list(cert) do
    Enum.map(cert, &to_json_safe/1)
  end

  def to_json_safe(cert) when is_binary(cert) do
    if String.valid?(cert) do cert else Base.encode64(cert) end
  end

  def to_json_safe(cert) do
    cert
  end
end