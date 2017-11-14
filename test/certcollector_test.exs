defmodule CertcollectorTest do
  use ExUnit.Case

  test "greets the world" do
  	assert Certcollector.get_cert("google.com") == google_fixture()
  end

  defp google_fixture do
  	with {:ok, pem} <- File.read("test/fixtures/googlecom.crt"),
  	     [{:Certificate, pem_decoded, :not_encrypted}] <- :public_key.pem_decode(pem),
  	     do: :public_key.pkix_decode_cert(pem_decoded, :otp)
	end
end
