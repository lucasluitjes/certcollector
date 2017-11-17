defmodule CertcollectorTest do
  use ExUnit.Case

  test "Grab a certificate from a server" do
  	result = Certcollector.Grabber.get_cert("google.com")
    |> Certcollector.Storage.der_to_pem
    assert result == File.read!("test/fixtures/googlecom.crt")
  end

  test "Generate file name for cert" do
    result = Certcollector.Storage.crt_path("certs", google_fixture())
    assert result == "certs/crt/b831f8a20e5bf2c6ea4096a8ec6a309931034102b3164157828e0756955d42fd.crt"
  end

  test "Test json encode" do
  	{:ok, result} = google_fixture()
    |> Certcollector.Parser.parse
    |> Poison.encode(pretty: true)
    {:ok, fixture} = File.read("test/fixtures/googlecom.json")
    assert result == fixture
  end

  defp google_fixture do
  	with {:ok, pem} <- File.read("test/fixtures/googlecom.crt"),
         [{:Certificate, cert, :not_encrypted}] <- :public_key.pem_decode(pem),
  	     do: cert
	end
end