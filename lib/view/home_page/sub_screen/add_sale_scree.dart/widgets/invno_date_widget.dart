import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';

class InvoiceHeaderWidget extends StatelessWidget {
  final String? invoiceNumber;
  final String? date;
  // final String? titleOne;
  final bool? hideInvoice;
  final String? titleTwo;
  final Function()? onTapDate;
  final Function()? ontapInvoice;
  const InvoiceHeaderWidget({
    super.key,
    this.ontapInvoice,
    this.invoiceNumber,
    this.date,
    // this.titleOne,
    this.hideInvoice,
    this.titleTwo,
    this.onTapDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Invoice Number with dropdown arrow
        GestureDetector(
          onTap: ontapInvoice,
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: 'Invoice No.: ',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: invoiceNumber,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                EneftyIcons.arrow_down_outline,
                size: 20,
                color: Colors.black,
              ),
            ],
          ),
        ),

        // Vertical Divider
        Container(
          height: 20,
          width: 1,
          color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(horizontal: 10),
        ),

        // Date with dropdown arrow
        GestureDetector(
          onTap: onTapDate,
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: 'Date: ',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: date,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                EneftyIcons.arrow_down_outline,
                size: 20,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
