defmodule CertcollectorTest do
  use ExUnit.Case

  test "grab a certificate from a server" do
  	assert Certcollector.get_cert("google.com") == google_fixture()
  end

  test "test json encode" do
  	google_fixture() |> Certcollector.to_json_safe |> Poison.encode
  end

  defp google_fixture do
  	with {:ok, pem} <- File.read("test/fixtures/googlecom.crt"),
  	     [{:Certificate, pem_decoded, :not_encrypted}] <- :public_key.pem_decode(pem),
  	     do: :public_key.pkix_decode_cert(pem_decoded, :otp)
	end
end
