defmodule Certcollector.Parser do 
  def parse(cert) do
    :public_key.pkix_decode_cert(cert, :otp) |> to_json_safe
  end

  def to_json_safe([:dNSName, name]) do
    [:dNSName, to_string(name)]
  end

  def to_json_safe([:uniformResourceIdentifier, name]) do
    [:uniformResourceIdentifier, to_string(name)]
  end

  def to_json_safe([:printableString, name]) do
    [:printableString, to_string(name)]
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