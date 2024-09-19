import qrcode
from qrcode.image.styledpil import StyledPilImage  # type: ignore
from qrcode.image.styles.moduledrawers.pil import VerticalBarsDrawer  # type: ignore

img_link = "https://www.naver.com/"

# Create QR code instance
qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,  # Error correction level
    box_size=10,  # size of each "box" in the QR code
    border=1,  # thickness of the border
)

qr.add_data(img_link)
qr.make(fit=True)

# Create an image from the QR code instance
img = qr.make_image(image_factory=StyledPilImage, module_drawer=VerticalBarsDrawer())
img.save("qrcode.png")

print("QR code generated and saved as 'qrcode.png'.")
