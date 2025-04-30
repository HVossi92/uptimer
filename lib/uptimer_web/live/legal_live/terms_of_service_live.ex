defmodule UptimerWeb.Legal.TermsOfServiceLive do
  use UptimerWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8 max-w-4xl">
      <div class="bg-white dark:bg-gray-800 shadow-md rounded-lg p-6 sm:p-8">
        <h1 class="text-3xl font-bold text-gray-900 dark:text-gray-100 mb-6">Terms of Service</h1>

        <div class="prose dark:prose-invert max-w-none">
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Last updated: {Date.utc_today() |> Date.to_string()}
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            1. Acceptance of Terms
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            By accessing or using the Uptimer service ("Service"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, please do not use our Service.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            2. Description of Service
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Uptimer provides a website monitoring service that allows users to track the uptime and performance of their websites. As part of this service, we generate thumbnails of your websites to provide visual confirmation of their appearance and status.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            3. User Accounts
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            To use certain features of our Service, you must create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            4. User Responsibilities and Conduct
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            You agree to use our Service only for lawful purposes and in accordance with these Terms. You are solely responsible for:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>The websites you choose to monitor using our Service</li>
            <li>Ensuring you have all necessary rights and permissions to monitor these websites</li>
            <li>Complying with all applicable laws and regulations</li>
          </ul>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            5. Website Thumbnails
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Our Service generates and stores thumbnail images of the websites you monitor. By using our thumbnail feature, you agree to the following:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>
              You will only monitor websites for which you have legal right to access and create thumbnails
            </li>
            <li>
              You will not monitor websites containing content that infringes on intellectual property rights, contains illegal material, or violates any third-party rights
            </li>
            <li>
              You understand that the thumbnails are for personal monitoring purposes only and should not be redistributed or used commercially
            </li>
            <li>
              You acknowledge that thumbnails are created automatically and we do not review their content prior to generation
            </li>
          </ul>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We reserve the right to delete any thumbnails that violate these Terms or that we determine, in our sole discretion, may create legal liability for Uptimer.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            5.1 Third-Party Websites and iFrames
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            As part of our Service, we may display websites you monitor within iframes. By using our Service, you acknowledge and agree to the following:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>
              We are not responsible or liable in any way, shape, or form for any content, data, files, cookies, or other material that may come from websites embedded in iframes
            </li>
            <li>We have no influence over or control of third-party websites displayed in iframes</li>
            <li>
              These third-party websites may have their own terms of service, privacy policies, and practices that differ from ours
            </li>
            <li>
              These websites may collect data, set cookies, or use other tracking technologies according to their own policies
            </li>
            <li>
              Any interaction you have with content inside these iframes is between you and the third-party website
            </li>
          </ul>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            You agree to review the terms and privacy policies of any websites you choose to monitor through our Service. Your use of our Service to monitor a website does not alter your legal relationship with that website or its owner.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            6. Intellectual Property Rights
          </h2>
          <h3 class="text-lg font-medium text-gray-800 dark:text-gray-200 mt-4 mb-2">
            6.1 Our Intellectual Property
          </h3>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            The Service and its original content, features, and functionality are owned by Uptimer and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.
          </p>

          <h3 class="text-lg font-medium text-gray-800 dark:text-gray-200 mt-4 mb-2">
            6.2 Third-Party Intellectual Property
          </h3>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Website thumbnails may contain third-party intellectual property. We respect the intellectual property rights of others and expect our users to do the same. We believe the creation of thumbnails for personal monitoring purposes constitutes fair use under copyright law, but we take intellectual property concerns seriously.
          </p>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            If you believe that material accessible via our Service infringes your copyright, you may notify us in accordance with our Copyright Policy (Section 10).
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            7. Free and Paid Accounts
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We offer both free and paid subscription plans. Free accounts are limited to 4 thumbnails. By subscribing to a paid plan, you agree to our payment terms and conditions.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            8. Limitation of Liability
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            In no event shall Uptimer be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>Your access to or use of or inability to access or use the Service</li>
            <li>Any conduct or content of any third party on the Service</li>
            <li>Any content obtained from the Service</li>
            <li>Unauthorized access, use, or alteration of your transmissions or content</li>
          </ul>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            9. Disclaimer
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Your use of the Service is at your sole risk. The Service is provided on an "AS IS" and "AS AVAILABLE" basis. The Service is provided without warranties of any kind, whether express or implied, including, but not limited to, implied warranties of merchantability, fitness for a particular purpose, non-infringement, or course of performance.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            10. Copyright Policy
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We respect the intellectual property rights of others and expect our users to do the same. We will respond to notices of alleged copyright infringement that comply with applicable law and are properly provided to us.
          </p>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            If you believe that your content has been copied in a way that constitutes copyright infringement, please provide us with the following information:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>
              An electronic or physical signature of the copyright owner or a person authorized to act on their behalf
            </li>
            <li>Identification of the copyrighted work claimed to have been infringed</li>
            <li>
              Identification of the material that is claimed to be infringing and where it is located on the Service
            </li>
            <li>Your contact information, including email address and phone number</li>
            <li>
              A statement that you have a good faith belief that use of the material in the manner complained of is not authorized by the copyright owner, its agent, or law
            </li>
            <li>
              A statement, made under penalty of perjury, that the above information is accurate and that you are the copyright owner or are authorized to act on behalf of the owner
            </li>
          </ul>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We reserve the right to remove content alleged to be infringing without prior notice, at our sole discretion, and without liability to you.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            11. Termination
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms. Upon termination, your right to use the Service will immediately cease. If you wish to terminate your account, you may simply discontinue using the Service or delete your account.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            12. Governing Law
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            These Terms shall be governed and construed in accordance with the laws of the European Union and its member states, without regard to its conflict of law provisions.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            13. Changes to Terms
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will provide notice of any changes by posting the new Terms on this page and updating the "Last updated" date at the top. You are advised to review these Terms periodically for any changes.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            14. Contact Us
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            If you have any questions about these Terms, please contact us at:
          </p>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            <a
              href="mailto:terms@uptimer.example.com"
              class="text-blue-600 dark:text-blue-400 hover:underline"
            >
              hendrik.vosskamp@gmail.com
            </a>
          </p>
        </div>
      </div>
    </div>
    """
  end
end
