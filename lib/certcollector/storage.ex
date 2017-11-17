defmodule Certcollector.Storage do 
  def store_certificate(base_dir, cert) do
  	unless File.exists?(crt_path(base_dir, cert)) do
  	  :ok = File.write(crt_path(base_dir, cert), der_to_pem(cert))
  	end
  end

	def der_to_pem(cert) do
		der_decoded = :public_key.der_decode(:Certificate, cert)
	  pem_entry = :public_key.pem_entry_encode(:Certificate, der_decoded)
	  :public_key.pem_encode([pem_entry])
	end

  def crt_path(base_dir, cert) do
  	Path.join([base_dir, "crt", hash_cert(cert) <> ".crt"])
  end

  defp hash_cert(cert) do
  	:crypto.hash(:sha256, cert) |> Base.encode16(case: :lower)
  end
end